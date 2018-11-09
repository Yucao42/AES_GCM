Fri 09 Nov 2018 03:09:08 PM UTC
1. Features:

	Key_gen module  4-pipelined  critical path 333MHz

    GHash_multiply  1-pipelined                400MHz (approxi.)

    AES_encryption 10-pipelined                500MHz (approxi.)

	Theoretical throughput: 128 * 333 / 1000 = 42.6 Gb/s

	Initial Latency:        15 * 1 / 333     = 4.5  us
