# rename the spec file and operating directory
git mv ansibleapp.yml apb.yml
git mv ansibleapp/ apb/

# update the spec and documentation
# do not use /g on this first since we only want to
# change the org name
perl -pi -e 's/ansibleapp\//ansibleplaybookbundle\//' apb.yml
perl -pi -e 's/ansibleapp/apb/g' apb.yml
perl -pi -e 's/ansibleapp/apb/g' README.md
perl -pi -e 's/AnsibleApp/Ansible Playbook Bundle/g' README.md
git add apb.yml
git add README.md

# update the ansible-container created files
perl -pi -e 's/ansibleapp/apb/' ansible/shipit-openshift.yml
git add ansible/shipit-openshift.yml

pushd ansible/roles
    TMPFILE=`mktemp`
    # don't use /g on the sed in this line
    ls -d *-ansibleapp-* | awk '{print "git mv "$1" "$1}' | sed 's/\(.*\)-ansibleapp/\1-apb/' > $TMPFILE
    sh $TMPFILE

    AC_FILES=`find . -name '*.yml' -o -name README`
    for f in $AC_FILES
    do
        perl -pi -e 's/ansibleapp/apb/g' $f
        git add $f
    done
popd

# update the actions
pushd apb/actions
FILES=`ls *.yaml`
for f in $FILES
do
    perl -pi -e 's/ansibleapp/apb/g' $f
    git add $f
done
popd

# regenerate the Dockerfile
apb prepare
git add Dockerfile
