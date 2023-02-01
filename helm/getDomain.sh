#!/bin/bash
kubectl get svc nginx-ingress-nginx-controller | awk '/nginx-ingress-nginx-controller/ {print $4}'
