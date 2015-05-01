SR_PREFIX ?= SR

$(SR_PREFIX)_DEFAULT_VERBOSITY = 0
$(SR_PREFIX)_SILENT_VERBOSITY = -1

V ?= $($(SR_PREFIX)_DEFAULT_VERBOSITY)

$(SR_PREFIX)_SILENT := $(and $(filter $($(SR_PREFIX)_SILENT_VERBOSITY),$(V)),silent)
$(SR_PREFIX)_DEFAULT := $(and $(filter $($(SR_PREFIX)_DEFAULT_VERBOSITY),$(V)),default)
$(SR_PREFIX)_VERBOSE := $(and $(filter-out $($(SR_PREFIX)_SILENT_VERBOSITY) $($(SR_PREFIX)_DEFAULT_VERBOSITY),$(V)),verbose)

$(SR_PREFIX)_VERBOSITY_MODE := $(or $($(SR_PREFIX)_SILENT),$($(SR_PREFIX)_DEFAULT),$($(SR_PREFIX)_VERBOSE))

$(SR_PREFIX)_NOT_SILENT := $(filter-out silent,$($(SR_PREFIX)_VERBOSITY_MODE))
$(SR_PREFIX)_NOT_DEFAULT := $(filter-out default,$($(SR_PREFIX)_VERBOSITY_MODE))
$(SR_PREFIX)_NOT_VERBOSE := $(filter-out verbose,$($(SR_PREFIX)_VERBOSITY_MODE))

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
