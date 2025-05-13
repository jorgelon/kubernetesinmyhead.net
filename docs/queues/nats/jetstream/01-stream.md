# Stream

A nats stream is a messsage store with some settings like the retention. It is related with nats subjects, and any message published there will be stored in the configured storage

## Configuration

We can see the settings of an stream with

```shell
nats stream info STREAM
```

## Basic Settings

- The name of the stream

- Description

- The storage type. It can be file (default) or memory

- The list of subjects to bind

- The replicas to keep for each message

- Mirror stream. A stream can be configured as a mirror of another stream.

## Limits and discard policy

- Maximum Messages (MaxMsgs)

Maximum number of messages stored in the stream. Adheres to Discard Policy, removing oldest or refusing new messages if the Stream exceeds this number of messages.

- Maximum Age (MaxAge)

Maximum age to keep any message in the Stream, expressed in nanoseconds

- Maximum Bytes (MaxBytes)

Maximum number of bytes stored in the stream, maximum bytes to keep. Adheres to Discard Policy, removing oldest or refusing new messages if the Stream exceeds this size.

- Maximum Message Size (MaxMsgSize)
The largest message that will be accepted by the Stream. The size of a message is a sum of payload and headers.

- Maximum Consumers (MaxConsumers)
Maximum number of Consumers allowed, that can be defined for a given Stream, -1 for unlimited. Cannot be edited

- Discard policy

**DiscardOld** (default) will delete the oldest messages in order to maintain the limit.

**DiscardNew** will reject new messages from being appended to the stream if it would exceed one of the limits. An extension to this policy is DiscardNewPerSubject which will apply this policy on a per-subject basis within the stream.
An extension to this policy is DiscardNewPerSubject which will apply this policy on a per-subject basis within the stream.

- DiscardNewPerSubject

If true, applies discard new semantics on a per subject basis. Requires DiscardPolicy to be DiscardNew and the MaxMsgsPerSubject to be set.
