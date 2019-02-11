"""Demonstrates how to construct and send raw Ethernet packets on the
network.
You probably need root privs to be able to bind to the network interface,
e.g.:
    $ sudo python trans.py
"""

from socket import *
import time

def sendeth(src, dst, eth_type, payload, interface = "eth2"):
  """Send raw Ethernet packet on interface."""

  assert(len(src) == len(dst) == 6) # 48-bit ethernet addresses
  assert(len(eth_type) == 2) # 16-bit ethernet type

  s = socket(AF_PACKET, SOCK_RAW, htons(3))

  # From the docs: "For raw packet
  # sockets the address is a tuple (ifname, proto [,pkttype [,hatype]])"
#  print('Src: {}\nDst: {}'.format(src.decode('hex'), dst.decode('hex')))
  s.bind((interface, 1))
  #s.send(dst + src + eth_type + payload)

  #print(src + dst+ eth_type + payload)
  #print s.recv(4096)
  #return 29
  return s.send(dst + src+ eth_type + payload)

if __name__ == "__main__":
  for i in range(1):
    print(i, "Sent %d-byte Ethernet packet on nf1" %
      sendeth("\x3c\xfd\xfe\xbd\x01\xa4",
              #"\x02\x53\x55\x4d\x45\x00",
              "\x3c\xfd\xfe\xbd\x01\xa5",
              #"\x02\x53\x55\x4d\x45\x00",
              "\x08\x01",
              #"\x7A\x05",
    "hello? I'm fine"))
    #time.sleep(1)


