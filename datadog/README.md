
We are using Datadog external helm chart.
https://github.com/DataDog/helm-charts/tree/main/charts/datadog 


Since the Official Helm chart is challenged when deployed on k3d (no /etc/passwd on k3d "machine"), we use this work around:
https://github.com/DataDog/helm-charts/issues/273 
This is why we need the datadog-passwd-fix.sh

In order to use it we need to run the datadog helm chart like that:
helm upgrade --install datadog datadog/datadog  -f datadog/values.yaml --set datadog.apiKey="${DD_API_KEY}" --set datadog.clusterName="on-prem-${ORG_ID}" --version 3.20.1 --post-renderer=./datadog/datadog-passwd-fix.sh

The values_orig.yaml is just for referrence for future use. It is not part of the deploy. 






