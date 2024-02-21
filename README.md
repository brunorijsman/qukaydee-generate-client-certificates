# The QuKayDee QKD network simulator

The bash scripts in this repository are intended to be used in conjunction with
QuKayDee ([https://qukaydee.com](https://qukaydee.com)) which is a cloud-based
[Quantum Key Distribution (QKD)](https://en.wikipedia.org/wiki/Quantum_key_distribution)
network simulator.

The simulated QKD network running in QuKayDee consists of simulated QKD devices that produce
encryption keys.
These encryption keys are stored in simulated Key Management Systems (KMSs) that also run in
QuKayDee.

The users of QuKayDee have encryption devices at their own location, outside of QuKayDee.
These encryption devices consume the keys that are produced by by simulated QKD devices and stored
in the simulated KMS devices.

The simulated KMS devices in QuKayDee provide a standard REST API defined in
[ETSI GS QKD 014](https://www.etsi.org/deliver/etsi_gs/QKD/001_099/014/01.01.01_60/gs_qkd014v010101p.pdf)
for delivering the generated encryption keys to the user's encryptors.

See the QuKayDee tutorial
([https://qukaydee.com/pages/tutorial](https://qukaydee.com/pages/tutorial))
for more details.

# The need for client certificates and keys
