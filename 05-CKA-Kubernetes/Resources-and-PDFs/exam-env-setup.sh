#!/usr/bin/env bash
# CKA Exam Environment Setup
# Source this file at the start of every practice session and on exam day:
#   source exam-env-setup.sh
#
# The CKA exam terminal already has kubectl installed. These aliases and
# exports are standard optimizations used by high-scoring candidates to
# cut command length and generate boilerplate YAML without typing it manually.

# ─── Core Alias ───────────────────────────────────────────────────────────────
alias k='kubectl'

# ─── Dry-run YAML generator ───────────────────────────────────────────────────
# Usage: k run nginx --image=nginx $do > pod.yaml
export do='--dry-run=client -o yaml'

# ─── Fast delete (no wait for graceful termination) ───────────────────────────
export now='--force --grace-period=0'

# ─── kubectl output shortcuts ─────────────────────────────────────────────────
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgn='kubectl get nodes'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kdn='kubectl describe node'
alias kl='kubectl logs'
alias ke='kubectl exec -it'

# ─── Namespace shortcut ───────────────────────────────────────────────────────
# Usage: kn kube-system   (sets current namespace for the session)
alias kn='kubectl config set-context --current --namespace'

# ─── Context shortcuts ────────────────────────────────────────────────────────
alias kctx='kubectl config get-contexts'
alias kuse='kubectl config use-context'

# ─── vim config for YAML editing ──────────────────────────────────────────────
# The exam gives you vim. Set these so YAML indentation doesn't betray you.
# Paste into ~/.vimrc or run :set ... manually in vim during the exam.
cat << 'VIMRC'

Paste into ~/.vimrc before exam tasks:
  set tabstop=2
  set expandtab
  set shiftwidth=2
  set autoindent

VIMRC

# ─── bash completion (if not already active) ──────────────────────────────────
if command -v kubectl &>/dev/null; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl k
fi

# ─── etcd backup one-liner (memorize this) ────────────────────────────────────
# ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
#   --endpoints=https://127.0.0.1:2379 \
#   --cacert=/etc/kubernetes/pki/etcd/ca.crt \
#   --cert=/etc/kubernetes/pki/etcd/server.crt \
#   --key=/etc/kubernetes/pki/etcd/server.key

# ─── kubeadm upgrade sequence (memorize this) ─────────────────────────────────
# 1. kubectl drain <node> --ignore-daemonsets
# 2. apt-get install -y kubeadm=<version>
# 3. kubeadm upgrade apply <version>   (control plane) OR kubeadm upgrade node (workers)
# 4. apt-get install -y kubelet=<version> kubectl=<version>
# 5. systemctl daemon-reload && systemctl restart kubelet
# 6. kubectl uncordon <node>

echo "CKA exam environment loaded. Try: k get nodes"
