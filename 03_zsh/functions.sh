
pubkey() {
    [ ! -f $1 ] && echo "This is not a valid faile at this path $1" && exit 1;
    more $1 | pbcopy | echo '=> Public key copied to pasteboard.'
}
