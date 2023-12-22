function h {
  http --pretty=all --print=hb "$@" | less -R;
}
