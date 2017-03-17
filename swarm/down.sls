
# We need to clear the salt mine so that we can use new values, such as IP
# addresses and keys.
clear-salt-mine:
  salt.function:
    - name: cache.clear_mine
    - tgt: '*'

# Leave the swarm, by force if necessary. Not the best approach, and will fix in a future update.
leave-swarm:
  cmd.run:
    - docker swarm leave --force
