import requests



link = "http://ipv4.icanhazip.com"


ip = requests.get(link)


print(ip.text)