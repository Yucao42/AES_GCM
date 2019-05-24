
"""Demonstrates how to construct and send raw Ethernet packets on the
network.
You probably need root privs to be able to bind to the network interface,
e.g.:
    $ sudo python sendeth.py
"""

from socket import *
import time

def sendeth(src, dst, eth_type, payload, interface = "eth2"):
  """Send raw Ethernet packet on interface."""

  assert(len(src) == len(dst) == 6) # 48-bit ethernet addresses
  assert(len(eth_type) == 2) # 16-bit ethernet type

  s = socket(AF_PACKET, SOCK_RAW)

  # From the docs: "For raw packet
  # sockets the address is a tuple (ifname, proto [,pkttype [,hatype]])"
  s.bind((interface, 1535))
  return s.send(dst + src+ eth_type + payload)

if __name__ == "__main__":
  import sys
  if len(sys.argv) > 1:
    for i in range(1):
      print(i, "Sent %d-byte Ethernet packet on nf1" %
        sendeth("\x3c\xfd\xfe\xbd\x01\xa4",
                "\x3c\xfd\xfe\xbd\x01\xa5",
                "\x88\x00",
                "\xFF\xFF" +
                sys.argv[1].decode('hex')))
  else:
    for i in range(1):
      print(i, "Sent %d-byte Ethernet packet on nf1" %
        sendeth("\x3c\xfd\xfe\xbd\x01\xa4",
                "\x3c\xfd\xfe\xbd\x01\xa5",
                "\x3c\xfd",
                "\xFF\xFF" +
                "\x22\x22\x01\x02\x12\x34\x12\x34\x22\x98\xab\xde\x2f\xee\x21\x22" +
                "\x22\x22\x01\x02\x12\x34\x12\x34\x22\x98\xab\xde\x2f\xee\x21\x22" +
                "\x22\x22\x01\x02\x12\x34\x12\x34\x22\x98\xab\xde\x2f\xee\x21\x22" +
                "\x22\x22\x01\x02\x12\x34\x12\x34\x22\x98\xab\xde\x2f\xee\x21\x22" * 80))
