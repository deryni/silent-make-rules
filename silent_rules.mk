SR_PREFIX ?= SR

$(SR_PREFIX)_DEFAULT_VERBOSITY = 0
$(SR_PREFIX)_SILENT_VERBOSITY = -1

V ?= $($(SR_PREFIX)_DEFAULT_VERBOSITY)

define vrule
$(SR_PREFIX)_V_$(1) = $$($(SR_PREFIX)_V_$(1)_$$(V))
$(SR_PREFIX)_V_$(1)_ = $$($(SR_PREFIX)_V_$(1)_$$($(SR_PREFIX)_DEFAULT_VERBOSITY))
$(SR_PREFIX)_V_$(1)_$($(SR_PREFIX)_DEFAULT_VERBOSITY) = @echo $(2);
$(SR_PREFIX)_V_$(1)_$($(SR_PREFIX)_SILENT_VERBOSITY) := @
ifndef $(SR_PREFIX)_V_$(1)_$(V)
    $(SR_PREFIX)_V_$(1)_$(V) :=
endif
endef

# -n prevents echo from printing an empty line.
$(eval $(call vrule,AT,-n))

$(eval $(call vrule,GEN,GEN $$@))
