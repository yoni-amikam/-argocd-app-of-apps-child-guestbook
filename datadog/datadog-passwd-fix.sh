#!/bin/sh
exec yq e 'del(.. | select(has("name")) | select(.name == "passwd"))' -

