{
  lib,
  config,
  ...
} @ args: let
  inherit (lib) mkEnableOption mkOption optionalAttrs;
  inherit (lib.types) str enum submodule;
  util = import ./util.nix args;
  customTypes = import ./types.nix args;
in {
  options = {
    provider = mkOption {
      description = ''
        Network provider (valid values: custom`).
      '';
      type = enum [
        "custom"
      ];
      default = "custom";
    };

    podCIDR = mkOption {
      description = ''
        Pod network CIDR to use in the cluster.
      '';
      type = customTypes.cidr;
      default = "10.244.0.0/16";
    };

    serviceCIDR = mkOption {
      description = ''
        Network CIDR to use for cluster VIP services.
      '';
      type = customTypes.cidr;
      default = "10.96.0.0/12";
    };

    clusterDomain = mkOption {
      description = ''
        Cluster Domain to be passed to the [kubelet](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/#kubelet-config-k8s-io-v1beta1-KubeletConfiguration)
        and the coredns configuration.
      '';
      type = customTypes.dnsName;
      default = "cluster.local";
    };

    kubeProxy = mkOption {
      description = "Defines the configuration for kube-proxy.";
      type = submodule (import ./kubeProxy.nix);
      default = {};
    };

    nodeLocalLoadBalancing = mkOption {
      description = ''
        Configuration options related to k0s's node-local load balancing feature.

        **Note:** This feature is currently unsupported on ARMv7!
      '';
      type = submodule (import ./nllb.nix);
      default = {};
    };

    controlPlaneLoadBalancing = mkOption {
      description = "ControlPlaneLoadBalancingSpec defines the configuration options related to k0s's keepalived feature.";
      type = submodule (import ./cplb.nix);
      default = {};
    };
  };
}
