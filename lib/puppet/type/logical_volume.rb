Puppet::Type.newtype(:logical_volume) do
    ensurable

    newparam(:name) do
        desc "The name of the logical volume.  This is the unqualified name and will be
            automatically added to the volume group's device path (e.g., '/dev/$vg/$lv')."
        isnamevar
        validate do |value|
            if value.include?(File::SEPARATOR)
                raise ArgumentError, "Volume names must be entirely unqualified"
            end
        end
    end

    newparam(:volume_group) do
        desc "The volume group name associated with this logical volume.  This will automatically
            set this volume group as a dependency, but it must be defined elsewhere using the
            volume_group resource type."
    end

    newparam(:initial_size) do
        desc "The initial size of the logical volume. This will only apply to newly-created volumes"
        validate do |value|
            unless value =~ /^[0-9]+[KMGTPE]/i
                raise ArgumentError , "#{value} is not a valid logical volume size"
            end
        end
    end

    newproperty(:size) do
        desc "The size of the logical volume. Set to undef to use all available space"
        validate do |value|
            unless value =~ /^[0-9]+[KMGTPE]/i
                raise ArgumentError , "#{value} is not a valid logical volume size"
            end
        end
    end

    newproperty(:extents) do
        desc "The  number of logical extents to allocate for the new logical volume. Set to undef to use all available space"
        validate do |value|
            unless value =~ /^[0-9]+[%(vg|VG|pvs|PVS|free|FREE|origin|ORIGIN)]?/i
                raise ArgumentError , "#{value} is not a valid logical volume extent"
            end
        end
    end

    newparam(:stripe_size) do
        desc "Size of the stripe. This will only apply to newly-created volumes"
        validate do |value|
            unless value =~ /^(4|8|16|32|64|128|256|512)$/
                raise ArgumentError , "#{value} is not a valid number stripe size"
            end
        end
    end

    newparam(:stripe, :required_features => [:stripe_size]) do
        desc "The number of physical volumes to stripe cross. This will only apply to newly-created volumes"
        validate do |value|
            unless value.to_i >= 2 && value.to_i <= :max.to_i
                raise ArgumentError , "#{value} is not a valid number of physical volumes"
            end
        end
    end

    newparam(:type) do
      desc "Configures the logical volume type. AIX only"
    end

    newparam(:range) do
      desc "Sets the inter-physical volume allocation policy. AIX only"
      validate do |value|
        unless ['maximum','minimum'].include?(value)
          raise ArgumentError, "#{value} is not a valid range"
        end
      end
    end
end
