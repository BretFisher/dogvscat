# Test the role (docker-ee-install).

PWD=$(shell pwd)
VERSION ?= latest
ROLE_NAME = docker-ee-install
ROLE_PATH = /etc/ansible/roles/$(ROLE_NAME)
EEs ?=
TEST_VERSION = ansible --version
TEST_SYNTAX = ansible-playbook -vv -i 'localhost,' -c local $(ROLE_PATH)/tests/main.yml --syntax-check
TEST_SUBSCRIPTIONS = $(shell cat $(PWD)/tests/subscriptions.json)
TEST_PLAYBOOK = ansible-playbook -vv -i 'localhost,' -c local -e '$(TEST_SUBSCRIPTIONS)' -e docker_ee_version=$(VERSION) $(EEs) $(ROLE_PATH)/tests
TEST_CMD = $(TEST_VERSION) && $(TEST_SYNTAX) && $(TEST_PLAYBOOK)
TEST_IMAGE_UBUNTU ?= williamyeh/ansible:ubuntu
TEST_IMAGE_CENTOS ?= williamyeh/ansible:centos
DOCKER_COMMAND = docker run --rm -e "ROLE_NAME=$(ROLE_NAME)" -v /var/run/docker.sock:/var/run/docker.sock -v $(PWD):$(ROLE_PATH)

# Supported Docker EE versions.
VERSIONS = 17.06 17.03 latest

# Supported distributions (and versions).
DISTROS = ubuntu centos
CENTOS_VERSIONS = 7
UBUNTU_VERSIONS = 16.04 14.04

.PHONY: test

#
# Pull.
#

pull/ubuntu/%:
	docker image pull "$(TEST_IMAGE_UBUNTU)$*"

pull/centos/%:
	docker image pull "$(TEST_IMAGE_CENTOS)$*"

pull/ubuntu: $(addprefix pull/ubuntu/, $(UBUNTU_VERSIONS))

pull/centos: $(addprefix pull/centos/, $(CENTOS_VERSIONS))

pull: pull/ubuntu pull/centos

#
# Test.
#

# The following pattern uses VERSION, DISTROS, <DISTRO_NAME>_VERSIONS
# to generate rules like test/latest/ubuntu/16.04.
#
# $(1): Docker EE version to test.
# $(2): Distro to test upon.
# $(3): Distro version to test upon.
define generate_test
test/install/$(1)/$(2)/%: pull/$(2)/%
	@echo "$$@..."
	@mkdir -p .$$(@D)
	@if ! $$(DOCKER_COMMAND) "$$(TEST_IMAGE_$(shell echo $(2) | tr a-z A-Z))$$*" /bin/bash -c "$$(TEST_CMD)"/main.yml > .$$@.log; then \
		cat .$$@.log; \
		exit 1; \
	fi

test/update/$(2)/%: pull/$(2)/%
	@echo "$$@..."
	@mkdir -p .$$(@D)
	@if ! $$(DOCKER_COMMAND) "$$(TEST_IMAGE_$(shell echo $(2) | tr a-z A-Z))$$*" /bin/bash -c "$$(TEST_CMD)"/update.yml > .$$@.log; then \
		cat .$$@.log; \
		exit 1; \
	fi

test/install/$(1)/$(2): $$(addprefix test/install/$(1)/$(2)/, $$($(shell echo $(2) | tr a-z A-Z)_VERSIONS))

endef

define generate_test_for_version
test/$(1): $$(addprefix test/$(1)/, $$(DISTROS))

endef

# Generate a rule for every combination (version, distro, distro_version).
$(eval														\
	$(foreach docker, $(VERSIONS),							\
		$(call generate_test_for_version,$(docker))			\
		$(foreach distro, $(DISTROS),						\
			$(call generate_test,$(docker),$(distro)))))

# Add convenient rule -> test: test/<versions>...
test: $(addprefix test/, $(VERSIONS))
