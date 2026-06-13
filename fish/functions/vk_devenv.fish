function vk_devenv
  set -x --path VULKAN_SDK $(realpath ~/vulkan/1.4.350.0/x86_64/)
  set -x --path --prepend PATH $(realpath $VULKAN_SDK/bin)
  set -x --path --prepend LD_LIBRARY_PATH $VULKAN_SDK/lib
  set -x --path VK_ADD_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
  set -x --path --prepend PKG_CONFIG_PATH $VULKAN_SDK/share/pkgconfig:$VULKAN_SDK/lib/pkgconfig
  set -x --path --prepend CMAKE_PREFIX_PATH $VULKAN_SDK:$VULKAN_SDK/lib/VulkanLoader
end
