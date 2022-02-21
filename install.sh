set +e

this=$(realpath $0)
parent=$(dirname $this)

for fn in $(find dot_configs/ -iname \.\*); do
	cmd="ln -fs ${parent}/$fn $HOME/$(basename $fn)"
	$cmd
done
