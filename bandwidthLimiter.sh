#!/bin/sh

ipfw pipe 1 config bw 250kbit/s
ipfw add pipe 1 dst-port http

echo "Use 'ipfw delete pipe 1' to remove the bandwidth limit."

