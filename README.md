*基于Linuxserver/jellyfin*

[Docker Hub](https://hub.docker.com/r/l299174105/jellyfin)

#### 解决中文封面字体乱码 添加中文字体✅

### 支持架构:
| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |

### 示例代码

```bash
docker run -d \
  --name=jellyfin \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e JELLYFIN_PublishedServerUrl=192.168.0.5 `#optional` \
  -p 8096:8096 \
  -p 8920:8920 `#optional` \
  -p 7359:7359/udp `#optional` \
  -p 1900:1900/udp `#optional` \
  -v /path/to/library:/config \
  -v /path/to/tvseries:/data/tvshows \
  -v /path/to/movies:/data/movies \
  --restart unless-stopped \
  l299174105/jellyfin:latest
```
## 参数

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| 参数| 说明|
| :----: | --- |
| `-p 8096` | Http webUI. |
| `-p 8920` | Optional - Https webUI (you need to set up your own certificate). |
| `-p 7359/udp` | Optional - Allows clients to discover Jellyfin on the local network. |
| `-p 1900/udp` | Optional - Service discovery used by DNLA and clients. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use (e.g. Europe/London). |
| `-e JELLYFIN_PublishedServerUrl=192.168.0.5` | Set the autodiscovery response domain or IP address. |
| `-v /config` | Jellyfin data storage location. *This can grow very large, 50gb+ is likely for a large collection.* |
| `-v /data/tvshows` | Media goes here. Add as many as needed e.g. `/data/movies`, `/data/tv`, etc. |
| `-v /data/movies` | Media goes here. Add as many as needed e.g. `/data/movies`, `/data/tv`, etc. |
