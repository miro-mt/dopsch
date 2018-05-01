# dopsch

DevOps example

The goal of this example is to automate CICD process and Kubernetes cluster creation/deletion.

To do this I assume you have:

- gcloud command line
- google cloud account with a project/default zone created
- Google Cloud DNS API enabled
- kubectl, helm command line
- a domain name (you can use freenom.com to get a free one) and you have pointed it to google name servers
- wercker CICD account to build images from github and push them to quay.io repository

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

