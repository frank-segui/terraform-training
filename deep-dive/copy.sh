#! /bin/bash
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MOD=$DIR/mod-$1
DEST=$DIR/globo_web_app

rm -rf $DEST/website || echo ""
rm -rf $DEST/templates || echo ""
rm -rf $DEST/modules || echo ""
rm -rf $DEST/consul || echo ""
rm -rf $DEST/*.tf
rm -rf $DEST/*.tfvars
rm -rf $DEST/*.tfplan

cp -rf $MOD/website $DEST/website || echo ""
cp -rf $MOD/templates $DEST/templates || echo ""
cp -rf $MOD/modules $DEST/modules || echo ""
cp -rf $MOD/modules $DEST/consul || echo ""
cp -rf $MOD/*.tf $DEST
cp -rf $MOD/*.tfvars $DEST