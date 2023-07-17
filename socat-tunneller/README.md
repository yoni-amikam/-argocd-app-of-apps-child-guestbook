If the customer has a corporate proxy that necessitates routing all outbound traffic from the cluster through it,
it is crucial to configure the https_proxy setting accordingly.
However, since nginx does not comply with this configuration, we have implemented socat as a solution to effectively forward the requests in the desired manner.
The flow of traffic is as follows: client -> nginx -> socat -> corporate proxy -> internet.