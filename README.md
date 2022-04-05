
Example usage:

```
  - name: RSA key for rdiff-backup
    copy:
      src: "rdiff-backup"
      dest: /root/rdiff-backup
      directory_mode: 0700
      mode: 0600
      
  - name: Rdiff backup
    docker_container:
      name: rdiff-backup
      image: irsl/rdiff-backup
      env:
        DEST: "razoreater.duckdns.org::/mnt/sda2/geza"
        OPTIONS: "--exclude /data/transmission --exclude /data/*/config/log --exclude /data/**/tmp"
        BACKUP_INDICATE_DIR: /data/transmission/data/tv
      volumes:
      - /root/rdiff-backup:/root/.ssh
      - /data:/src
      restart_policy: unless-stopped
```
