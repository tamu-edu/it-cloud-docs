> [!NOTE]
> This site is a work in progress and will be updated regularly.  Please check back frequently for updates.

# The following is a test of the mermaid plugin for mdbook

```mermaid
flowchart TB
    internet_in(["🌐 Internet (ingress)"])

    subgraph afd["Azure Front Door (Global)"]
        direction TB
        fd_waf["WAF Policy<br>(Geo-block · Bot · OWASP)"]
        fd_lb["Layer-7 LB<br>(Hostname + Path Routing<br>TLS Termination)"]
        fd_waf --> fd_lb
    end

    %% Ingress: HTTP/HTTPS via Front Door
    internet_in -->|"HTTP/HTTPS"| afd
    fd_lb -- Private origin<br>(HTTPS) --> svc_a1
    fd_lb -- Private origin<br>(HTTPS) --> svc_b1

    %% Ingress: TCP/UDP via Firewall DNAT
    internet_in -->|"TCP/UDP"| fw
    fw -->|"DNAT private IP"| svc_a2
    fw -->|"DNAT private IP"| svc_b2


    subgraph hub["HUB VNet - Cloud Team"]
        direction TB
        fw["Azure Firewall<br>(Inspection · DNAT · Egress)"]
        nat["NAT Gateway"]
        gw["ExpressRoute"]
        fw --> nat
        fw ~~~ gw
    end

    subgraph spoke_a["Spoke VNet — Customer A"]
        svc_a1["Private Service<br>(App Service / App Gateway)"]
        svc_a2["Private Service<br>(VM / Container)"]
    end

    subgraph spoke_b["Spoke VNet — Customer B"]
        svc_b1["Private Service<br>(App Service / App Gateway)"]
        svc_b2["Private Service<br>(VM / Container)"]
    end
    
    wan(["🏛️ Campus / WAN"])
    internet_out(["🌐 Internet (egress)"])


    %% Spoke → HUB peering (egress / response)
    %% svc_a1 & svc_a2 <-- VNet Peering --> fw
    %% svc_b1 & svc_b2 <-- VNet Peering --> fw
    
    %% Egress to internet
    spoke_a -->|"Default Route"| fw
    nat -->|"Outbound internet"| internet_out
    spoke_b -->|"Default Route"| fw

    %% WAN connectivity
    gw <--> wan
    spoke_a <--> gw
    spoke_b <--> gw
```


# ^^ That should look like the network diagram we have in the forthcoming PRs.


This website is a resource for Texas A&M University faculty, and staff to learn about the various infrastructure and platform services available at Texas A&M University. This includes information about cloud services, platform services, and security policies and best practices.

It is maintained by a distributed team of engineers in Technology Services who contribute information relevant to their area of expertise.


## Contributing

If you are a member of the Texas A&M University community and would like to contribute to this website, please get involved over on [GitHub](https://github.com/tamu-edu/it-cloud-docs).

