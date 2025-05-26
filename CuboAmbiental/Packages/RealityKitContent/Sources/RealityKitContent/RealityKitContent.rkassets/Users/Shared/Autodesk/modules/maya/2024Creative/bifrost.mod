# For each module section in a .mod file, defined by
# + [module_name] [module_version] [module_path]
# Maya will try to find plugins to register based on [module_path].
# By default it will search in [module_path]/plug-ins.
#
# In this .mod file we define multiple modules to get around some limitations
# and be able to both append and prepend values to environment variables.
#
# When overriding a bifrost (v1) installation by using MAYA_MODULE_PATH pointing
# to another bifrost (v2), only modules from v1 that exists in v2 will be discarded.
# If v2 has modules that are not defined in v1, they will be processed, and
# that would result in plugins in both v1/[module_path]/plug-ins and
# v2/[module_path]/plug-ins to be registered in Maya which may causes issues !
#
# Therefore only from the Bifrost module should Maya be able to look for plugins.
# To achieve that, for the other modules, we redefine in which folder Maya should
# search for plugins, by using
# plug-ins: null
# With this Maya will look for plugins in [module_path]/null which is an invalid
# location.

############################################################
# NOTE: only use prepend (*:=) for BIFROST_LIB_CONFIG_FILES
#
# BIFROST_LIB_CONFIG_FILES*:=resources/plugin_config.json
# always last
############################################################

# Add dummy bifrostPacks to prevent bifrostPacks module from old mod files to be
# registered and which were not redefining the 'plug-ins' lookup.
+ bifrostPacks 2.7.1.1 /Applications/Autodesk/bifrost/maya2024/2.7.1.1/bifrost
plug-ins: null

+ PLATFORM:mac LOCALE:en_US Bifrost 2.7.1.1 /Applications/Autodesk/bifrost/maya2024/2.7.1.1/bifrost
BIFROST_LOCATION:=
[r] scripts: scripts
MAYA_CONTENT_PATH+:=examples/Bifrost_Fluids
MAYA_MODULE_UI_WORKSPACE_PATH+:=resources/workspaces
MAYA_TOOLCLIPS_PATH+:=resources/toolclips
BIFROST_LIB_CONFIG_FILES*:=packs/packs_plugin_config.json
BIFROST_LIB_CONFIG_FILES*:=resources/plugin_config.json
PYTHONPATH+:=python/site-packages

+ PLATFORM:mac LOCALE:zh_CN Bifrost 2.7.1.1 /Applications/Autodesk/bifrost/maya2024/2.7.1.1/bifrost
BIFROST_LOCATION:=
MAYA_PLUG_IN_RESOURCE_PATH+:=resources/l10n/zh_CN
[r] scripts: scripts
MAYA_CONTENT_PATH+:=examples/Bifrost_Fluids
MAYA_MODULE_UI_WORKSPACE_PATH+:=resources/workspaces
MAYA_TOOLCLIPS_PATH+:=resources/l10n/zh_CN
BIFROST_LIB_CONFIG_FILES*:=packs/packs_plugin_config.json
BIFROST_LIB_CONFIG_FILES*:=resources/plugin_config.json
PYTHONPATH+:=python/site-packages

+ PLATFORM:mac LOCALE:ja_JP Bifrost 2.7.1.1 /Applications/Autodesk/bifrost/maya2024/2.7.1.1/bifrost
BIFROST_LOCATION:=
MAYA_PLUG_IN_RESOURCE_PATH+:=resources/l10n/ja_JP
[r] scripts: scripts
MAYA_CONTENT_PATH+:=examples/Bifrost_Fluids
MAYA_MODULE_UI_WORKSPACE_PATH+:=resources/workspaces
MAYA_TOOLCLIPS_PATH+:=resources/l10n/ja_JP
BIFROST_LIB_CONFIG_FILES*:=packs/packs_plugin_config.json
BIFROST_LIB_CONFIG_FILES*:=resources/plugin_config.json
PYTHONPATH+:=python/site-packages
