# Don't like the default SR prefix on the silent rules?
# Define this variable before you include this file to change it.
SR_PREFIX ?= SR

# Need more arguments in your silent rules? Set this to the maximum you need.
$(SR_PREFIX)_arg_values ?= 1 2

# Set V in your main makefile to use a different default value.
# Set this on the command line to override it for that make execution.
V ?= $($(SR_PREFIX)_DEFAULT_VERBOSITY)

## EVERYTHING BELOW HERE IS INTERNAL. ##

$(SR_PREFIX)_DEFAULT_VERBOSITY = 0
$(SR_PREFIX)_SILENT_VERBOSITY = -1

$(SR_PREFIX)_SILENT := $(and $(filter $($(SR_PREFIX)_SILENT_VERBOSITY),$(V)),silent)
$(SR_PREFIX)_DEFAULT := $(and $(filter $($(SR_PREFIX)_DEFAULT_VERBOSITY),$(V)),default)
$(SR_PREFIX)_VERBOSE := $(and $(filter-out $($(SR_PREFIX)_SILENT_VERBOSITY) $($(SR_PREFIX)_DEFAULT_VERBOSITY),$(V)),verbose)

$(SR_PREFIX)_VERBOSITY_MODE := $(or $($(SR_PREFIX)_SILENT),$($(SR_PREFIX)_DEFAULT),$($(SR_PREFIX)_VERBOSE))

$(SR_PREFIX)_NOT_SILENT := $(filter-out silent,$($(SR_PREFIX)_VERBOSITY_MODE))
$(SR_PREFIX)_NOT_DEFAULT := $(filter-out default,$($(SR_PREFIX)_VERBOSITY_MODE))
$(SR_PREFIX)_NOT_VERBOSE := $(filter-out verbose,$($(SR_PREFIX)_VERBOSITY_MODE))

# Create $(val#) macros to use positional arguments without undefined variable
# warnings.
val=$$(and $$(filter-out undefined,$$(origin $1)),$$($1))
$(foreach arg,$($(SR_PREFIX)_arg_values),$(eval val$(arg) = $(call val,$(arg))))

define vrule
$(SR_PREFIX)_V_$(1) = $$($(SR_PREFIX)_V_$(1)_$$(V))
$(SR_PREFIX)_V_$(1)_ = $$($(SR_PREFIX)_V_$(1)_$$($(SR_PREFIX)_DEFAULT_VERBOSITY))
$(SR_PREFIX)_V_$(1)_$($(SR_PREFIX)_DEFAULT_VERBOSITY) = @printf -- %s$(and $(val2),\\n) '$$(subst ','\'',$(val2))';
$(SR_PREFIX)_V_$(1)_$($(SR_PREFIX)_SILENT_VERBOSITY) := @
ifndef $(SR_PREFIX)_V_$(1)_$(V)
    $(SR_PREFIX)_V_$(1)_$(V) :=
endif
endef

$(eval $(call vrule,AT))

$(eval $(call vrule,ECHO,$$(or $$(val1),ECHO)))
$(eval $(call vrule,GEN,GEN $$(or $$(val1),$$@)))

# The MIT License (MIT)
#
# Copyright (c) 2015-2016 Etan Reisner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
