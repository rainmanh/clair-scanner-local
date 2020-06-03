# clair-scanner Kubernetes

This is an example written for Kubernetes to setup The Container Scanner Clair as a Kubernetes setup with it's own private Kubernetes registry.

This is probably the base case scenario for implementing Clair and most straight forward as it deal on both cases with:
 * a Kubernetes private registry
 * a remote registry


To run it simply execute the init script:
```
init.sh [create/destroy]
```

_NOTE_: the database will be updating the definitions from the config.yaml file, it will take awhile.
Output example:

```
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"alpine.go:52","Time":"2020-06-03 15:58:16.305003","package":"Alpine"}
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"oracle.go:119","Time":"2020-06-03 15:58:16.304801","package":"Oracle Linux"}
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"amzn.go:84","Time":"2020-06-03 15:58:16.305530","package":"Amazon Linux 2018.03"}
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"amzn.go:84","Time":"2020-06-03 15:58:16.306030","package":"Amazon Linux 2"}
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"debian.go:63","Time":"2020-06-03 15:58:16.306277","package":"Debian"}
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"rhel.go:92","Time":"2020-06-03 15:58:16.322033","package":"RHEL"}
{"Event":"Start fetching vulnerabilities","Level":"info","Location":"ubuntu.go:85","Time":"2020-06-03 15:58:16.322420","package":"Ubuntu"}
{"Event":"finished fetching","Level":"info","Location":"updater.go:253","Time":"2020-06-03 15:58:18.036763","updater name":"alpine"}
{"Event":"finished fetching","Level":"info","Location":"updater.go:253","Time":"2020-06-03 15:58:18.098757","updater name":"amzn2"}
{"Event":"finished fetching","Level":"info","Location":"updater.go:253","Time":"2020-06-03 15:58:20.011408","updater name":"amzn1"}
{"Event":"finished fetching","Level":"info","Location":"updater.go:253","Time":"2020-06-03 15:58:21.209373","updater name":"debian"}
{"Event":"finished fetching","Level":"info","Location":"updater.go:253","Time":"2020-06-03 15:58:27.001128","updater name":"rhel"}

```

Now, you can run the scanning process with either:

* clair-scanner
* klar

## clair-scanner

Download the binary for your system architectre from: https://github.com/arminc/clair-scanner

To scan ensure you got the docker containers running and listening, then just simply do (example below running against my Kubernetes private registry):

```
 /usr Kubernetes/bin/clair-scanner --clair="http://127.0.0.1:30060" --ip="<your_box_ip>" localhost:5000/clair
```

## klar

You have to download klar: https://github.com/optiopay/klar 

Then you can proceed as the example below for a Private Registry. If you are using as a Private Registry the localhost, that will not resolve within the container, instead your have you use your hosts (laptop/instance...etc.) Ip instead..

```
CLAIR_ADDR=http://localhost:30060 CLAIR_OUTPUT=Low CLAIR_THRESHOLD=10 REGISTRY_INSECURE=TRUE klar 192.168.1.11:5000/postgres:9.6
```

### output example:

```
clair timeout 1m0s
docker timeout: 10m0s
no whitelist file
Analysing 14 layers
Got results from Clair API v1
Found 49 vulnerabilities
Unknown: 1
Negligible: 21
Low: 11
Medium: 12
High: 4

CVE-2019-8457: [High] 
Found in: sqlite3 [3.16.2-5+deb9u1]
Fixed By: 
SQLite3 from 3.6.0 to and including 3.27.2 is vulnerable to heap out-of-bound read in the rtreenode() function when handling invalid rtree tables.
https://security-tracker.debian.org/tracker/CVE-2019-8457
-----------------------------------------
CVE-2020-13630: [High] 
Found in: sqlite3 [3.16.2-5+deb9u1]
Fixed By: 
ext/fts3/fts3.c in SQLite before 3.32.0 has a use-after-free in fts3EvalNextRow, related to the snippet feature.
https://security-tracker.debian.org/tracker/CVE-2020-13630
-----------------------------------------
CVE-2019-9169: [High] 
Found in: glibc [2.24-11+deb9u4]
Fixed By: 
In the GNU C Library (aka glibc or libc6) through 2.29, proceed_next_node in posix/regexec.c has a heap-based buffer over-read via an attempted case-insensitive regular-expression match.
https://security-tracker.debian.org/tracker/CVE-2019-9169
-----------------------------------------
CVE-2018-1000001: [High] 
Found in: glibc [2.24-11+deb9u4]
Fixed By: 
In glibc 2.26 and earlier there is confusion in the usage of getcwd() by realpath() which can be used to write before the destination buffer leading to a buffer underflow and potential code execution.
https://security-tracker.debian.org/tracker/CVE-2018-1000001
-----------------------------------------
```

## Sources

* https://hub.docker.com/r/arminc/clair Kubernetes-scan
* https://github.com/quay/clair
* https://github.com/coreos/clair
* https://hub.docker.com/r/arminc/clair-db