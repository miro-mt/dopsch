# dopsch

DevOps example

The goal of this example is to automate CICD process and Kubernetes cluster creation/deletion.

To do this I assume you have:

- wercker CICD account to build images from github and push them to quay.io repository
- gcloud command line
- google cloud account with a project/default zone created
- kubectl, helm command line (latest versions, helm had a bug with tiller init and --wait)
- curl
- a domain name, this example uses DigitalOcean since freenom.com had API issues
	please specify DIGITAL_OCEAN_API_TOKEN environment variable or update DNS manually
	domain name should already have an A record for your subdomain
- jq command line for handling json input from DigitalOcean

Please edit common.sh and chart/values.yaml to your setup.

I've chosen nginx ingress for portability. Also, kube-lego instead of cert manager since at the moment
cert manager says it's not production ready even though it says it has more features.

Contains go code from https://github.com/golang/example/tree/master/outyet

### [dopsch](/) ([godoc](//godoc.org/github.com/miro-mt/dopsch))

    go get github.com/miro-mt/dopsch

A web server that answers the question: "Is Go 1.x out yet?"

Topics covered:

* Command-line flags ([flag](//golang.org/pkg/flag/))
* Web servers ([net/http](//golang.org/pkg/net/http/))
* HTML Templates ([html/template](//golang.org/pkg/html/template/))
* Logging ([log](//golang.org/pkg/log/))
* Long-running background processes
* Synchronizing data access between goroutines ([sync](//golang.org/pkg/sync/))
* Exporting server state for monitoring ([expvar](//golang.org/pkg/expvar/))
* Unit and integration tests ([testing](//golang.org/pkg/testing/))
* Dependency injection
* Time ([time](//golang.org/pkg/time/))

