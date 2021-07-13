from pprint import pprint

from hpeOneView.oneview_client import OneViewClient

import sys, argparse, getpass, json, re

from redfish import RedfishClient
from redfish.rest.v1 import ServerDownOrUnreachableError

"""
RedFish example : Mounting an iso on iLO VirtualMedia of a server managed by OneView
                  sso from oneview to ilo/redfish

Modules : hpeOneView 6.0.0 and python-ilorest-library 3.1.0
"""

__author__ = 'Olivier Desaphy - ode@hpe.com'

def GetArgs():
    """
    Supports the command-line arguments listed below.
    """
    parser = argparse.ArgumentParser(
        description='Process args')
    parser.add_argument('-o', '--oneview', required=True, action='store',
                        help='OneView http address')
    parser.add_argument('-s', '--sessionID', required=True, action='store',
                        help='OneView sessionID')
    parser.add_argument('-p', '--profile_name', required=True, action='store',
                        help='Server Profile Name')
    parser.add_argument('-m', '--media_url', required=True, action='store',
                        help='Media URL')
    args = parser.parse_args()
    return args

def mount_virtual_media_iso(_redfishobj, iso_url, media_type, boot_on_next_server_reset):

  virtual_media_uri = None
  virtual_media_response = []

  managers_uri = _redfishobj.root.obj['Managers']['@odata.id']
  managers_response = _redfishobj.get(managers_uri)
  managers_members_uri = next(iter(managers_response.obj['Members']))['@odata.id']
  managers_members_response = _redfishobj.get(managers_members_uri)

  virtual_media_uri = managers_members_response.obj['VirtualMedia']['@odata.id']

  if virtual_media_uri:
    virtual_media_response = _redfishobj.get(virtual_media_uri)
    for virtual_media_slot in virtual_media_response.obj['Members']:
      data = _redfishobj.get(virtual_media_slot['@odata.id'])
      if media_type in data.dict['MediaTypes']:
        if "Hpe" in data.dict['Oem'].keys():
          oemKey="Hpe"
          virtual_media_mount_uri = data.obj['Actions']['#VirtualMedia.InsertMedia']['target']
        else: 
          oemKey="Hp"
          virtual_media_mount_uri= data.obj['Oem']['Hp']['Actions']['#HpiLOVirtualMedia.InsertVirtualMedia']['target']

        post_body = {"Image": iso_url}

        if iso_url:
          resp = _redfishobj.post(virtual_media_mount_uri, post_body)
          if boot_on_next_server_reset is not None:
            print("setting BootOnNextServerReset")
            patch_body = {}
            patch_body["Oem"] = { oemKey: {"BootOnNextServerReset": boot_on_next_server_reset}}
            boot_resp = _redfishobj.patch(data.obj['@odata.id'], patch_body)
            if not boot_resp.status == 200:
              sys.stderr.write("Failure setting BootOnNextServerReset")
          if resp.status == 400:
            try:
              print(json.dumps(resp.obj['error']['@Message.ExtendedInfo'], indent=4, \
                                                                      sort_keys=True))
            except Exception as excp:
              sys.stderr.write("A response error occurred, unable to access iLO"
                                "Extended Message Info...")
          elif resp.status != 200:
            sys.stderr.write("An http response of \'%s\' was returned.\n" % resp.status)
          else:
            print("Success!\n")
            print(json.dumps(resp.dict, indent=4, sort_keys=True))
        break

def main():
  config = {
    "ip": None,
    "credentials": {
      "sessionID": None
    },
    "api_version": "2400"
  }

  media_type='DVD'
  bootOnNextReset=True

  args = GetArgs()
  config['ip'] = args.oneview
  config['credentials']['sessionID'] = args.sessionID
   
  media_url = args.media_url
  profile_name = args.profile_name

  oneview_client = OneViewClient(config)
  server_profiles = oneview_client.server_profiles
  servers = oneview_client.server_hardware
  print("\nGet a server profile by name")
  profile = server_profiles.get_by_name(profile_name)

  if profile:
    pprint("Server Profile uri: {}".format(profile.data["uri"]))
    if profile.data["serverHardwareUri"]:
      sh = servers.get_by_uri(profile.data["serverHardwareUri"])
      pprint("Server Hardware name: {}".format(sh.data["name"])) 
      remote_console_url = sh.get_remote_console_url()
      #pprint(remote_console_url)
      sessionKey= re.findall(r'sessionkey=([^&]*)', remote_console_url['remoteConsoleUrl'])
      iloAddr= re.findall(r'addr=([^&]*)', remote_console_url['remoteConsoleUrl'])

      if sessionKey[0]:
        try:
          REDFISHOBJ = RedfishClient(base_url="https://{}".format(iloAddr[0]))
          REDFISHOBJ.session_key = sessionKey[0]
          rootData=REDFISHOBJ.get('/redfish/v1')
          REDFISHOBJ.root = rootData
          response=REDFISHOBJ.get('/redfish/v1/sessions')
          if ("Hpe" in response.dict["Oem"]):
            oemKey = "Hpe"
          else:
            oemKey ="Hp"
          mySession = response.dict["Oem"][oemKey]["Links"]["MySession"]
          
          REDFISHOBJ.session_location = mySession["@odata.id"]
        except ServerDownOrUnreachableError as excp:
          sys.stderr.write("ERROR: server not reachable or does not support RedFish.\n")
          sys.exit()
        
        mount_virtual_media_iso(REDFISHOBJ, media_url, media_type, bootOnNextReset)

        REDFISHOBJ.logout()
        
        PowerConfiguration = {
        	"powerState": "On",
        	"powerControl": "MomentaryPress"
        	}
        	
        server_power = sh.update_power_state(PowerConfiguration)
        print("Successfully changed the power state of server")        
        

# Main section
if __name__ == "__main__":
  sys.exit(main())
