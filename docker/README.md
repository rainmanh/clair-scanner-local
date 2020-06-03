# clair-scanner Docker Composer

This is an example written for Docker Compose to setup The Container Scanner Clair as a local setup with it's own private local registry.

This is probably the base case scenario for implementing Clair and most straight forward as it deal on both cases with:

 * a local private registry
 * a remote registry


To run it simply do:
```
docker-compose -f clair-scanner.yaml  up -d
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

To scan ensure you got the docker containers running and listening, then just simply do (example below running against my local private registry):

```
 /usr/local/bin/clair-scanner --clair="http://127.0.0.1:6060" --ip="<your_box_ip>" localhost:5000/clair
```

## klar

You have to download klar: https://github.com/optiopay/klar 

Then you can proceed as the example below for a Private Registry. If you are using as a Private Registry the localhost, that will not resolve within the container, instead your have you use your hosts (laptop/instance...etc.) Ip instead..

```
CLAIR_ADDR=http://localhost:6060 CLAIR_OUTPUT=Low CLAIR_THRESHOLD=10 REGISTRY_INSECURE=TRUE klar 192.168.1.11:5000/postgres:9.6
```

### output example:

```
2020/06/02 12:51:33 [INFO] ▶ Start clair-scanner
2020/06/02 12:51:48 [INFO] ▶ Server listening on port 9279
2020/06/02 12:51:48 [INFO] ▶ Analyzing 69970c11d5e148aad8020cbe98433478ca5144d56579b2c1cd1185d628560839
2020/06/02 12:51:49 [INFO] ▶ Analyzing 5be2e35818e97000912d296d256c40836eaf273ae634f15bfe649fda65d3be5c
2020/06/02 12:51:49 [INFO] ▶ Analyzing 4328fb773b9a1380c4182e4a87eadaf50c6ce027cebd228f00813255f7639b75
2020/06/02 12:51:49 [INFO] ▶ Analyzing 92b9c310544f4f0993ac43bea66307482167f26048700cfbe444f0f0b336c31a
2020/06/02 12:52:02 [INFO] ▶ Analyzing ee96a3ee99d9fc2dcc93c500c205609c64d7ec42f53950cb6d78ecc669c1800e
2020/06/02 12:52:02 [INFO] ▶ Analyzing 6298f59a7d25ab507eaf5d5ae3226fc3bc55bd45ba7cbc449293830832238fb7
2020/06/02 12:52:04 [INFO] ▶ Analyzing 45c42bb596fb59cfef3d73d59d41091318814d59cad5cdef089c5d48f8090fd8
2020/06/02 12:52:07 [INFO] ▶ Analyzing c19695169bcba5ab61086a54d57917ab823a6fb11ab7b63ee1a2885d2dab24a7
2020/06/02 12:52:07 [WARN] ▶ Image [localhost:5000/clair] contains 7 total vulnerabilities
2020/06/02 12:52:07 [ERRO] ▶ Image [localhost:5000/clair] contains 7 unapproved vulnerabilities
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| STATUS     | CVE SEVERITY          | PACKAGE NAME | PACKAGE VERSION | CVE DESCRIPTION                                               |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | High CVE-2019-14697   | musl         | 1.1.20-r3       |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-14697 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | High CVE-2018-20843   | expat        | 2.2.6-r0        |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-20843 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | Medium CVE-2017-14502 | libarchive   | 3.3.2-r4        |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14502 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | Medium CVE-2017-14501 | libarchive   | 3.3.2-r4        |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14501 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | Medium CVE-2019-18408 | libarchive   | 3.3.2-r4        |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-18408 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | Medium CVE-2017-14503 | libarchive   | 3.3.2-r4        |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-14503 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+
| Unapproved | Medium CVE-2019-15903 | expat        | 2.2.6-r0        |                                                               |
|            |                       |              |                 | https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-15903 |
+------------+-----------------------+--------------+-----------------+---------------------------------------------------------------+

```

## Sources

* https://hub.docker.com/r/arminc/clair-local-scan
* https://github.com/quay/clair
* https://github.com/coreos/clair
* https://hub.docker.com/r/arminc/clair-db