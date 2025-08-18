# DOTYWRT

Custom OpenWrt applications, packages, and build scripts maintained under the **dotywrt** project.
 

Device : ARCADYAN AW1000  
Chipset: IPQ8074


### LuCI Applications
- **luci-app-aw1k-led**  
  Manage and control LED indicators on supported AW1K devices.

- **luci-app-dstore**  
  Web-based interface for Dotycat’s dstore service.

- **luci-app-netstat**  
  A lightweight LuCI frontend for monitoring network connections.

- **luci-app-nft-ttl**  
  Configure and manage nftables TTL modification rules through LuCI.

- **luci-app-occ**  
  OCC (One Click Config) converter: VLESS / VMess / Trojan configuration generator with a simple UI.

---

## ⚙️ Build Notes

This repository is designed to integrate with the OpenWrt build system:

```bash
# clone OpenWrt buildroot
git clone https://github.com/openwrt/openwrt.git
cd openwrt

# add dotywrt feed
echo "src-git dotywrt https://github.com/yourname/dotywrt.git" >> feeds.conf.default

# update feeds
./scripts/feeds update -a
./scripts/feeds install -a

# build as usual
make menuconfig
make
