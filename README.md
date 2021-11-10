# my-dockerfile

## Build

In PC:

```shell
docker build -tmy-docker .
```

In bitahub:

<https://www.bitahub.com/help/md/7.6%20%E8%87%AA%E5%AE%9A%E4%B9%89%E9%95%9C%E5%83%8F.html>

Building needs about 9 min in bitahub or about 20 min in my PC.

If build time > 20 min, bitahub will kill the process.

Homebrew will return error 1.

## Usage

Password is same as user name.

```shell
ssh -pPORT root@202.38.95.26
# password is "root"
# or
ssh -pPORT wzy@202.38.95.26
# password is ""
cd /data/username/datasetname
sudo chmod 777 .
```

Note, bitahub have backup for `/code`, which seems to result in commit failure
after scp any file to `/code`.
