# RTMP

Installs a multi-node design RTMP Streaming Platform.  

# Features  
### Design  
-Allows for multiple RTMP Ingest Nodes  
-Single Core RTMP Origin Server  
-Allows for multiple HLS Edge Nodes  
### Security  
- RTMP Authentication on Ingest via Stream Key  
- Origin Server only allows Ingest Server  

# Dependancies
-Ubuntu  
-Nginx with RTMP module  

# Installation
## Live (Read the Code first!) 
Ingest Server  

    bash <(curl -s https://raw.githubusercontent.com/EricServices-Repo/rtmp/main/ingest-server-install.sh)  
    
Origin Server  

    bash <(curl -s https://raw.githubusercontent.com/EricServices-Repo/rtmp/main/origin-server-install.sh)  
    
Edge Server  

    bash <(curl -s https://raw.githubusercontent.com/EricServices-Repo/rtmp/main/edge-server-install.sh)  
