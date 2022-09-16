.POSIX:

metal:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory=inventory.yaml playbook.yaml --ask-become-pass

rke2:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory=inventory.yaml playbook.yaml --ask-become-pass --tags rke2

console:
	ANSIBLE_HOST_KEY_CHECKING=False ansible-console --inventory=inventory.yaml --user ubuntu --private-key ~/.ssh/id_ed25519
