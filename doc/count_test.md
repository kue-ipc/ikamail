# test

メールのテスト

delayed_jobを有効にしておきます。

```
  # production queue delayed_job
  config.active_job.queue_adapter = :delayed_job
```

`bin/delayed_job -n 10 start`で起動しておきます。

コンソールで次を実行します。

```
ReservedDeliveryJob.set(wait_until: @bulk_mail.reserved_at).perform_later(@bulk_mail)

time = Time.current + 10.minutes
100.times do |n|
    bulk_mail = BulkMail.create!(
        user: User.first,
        mail_template: MailTemplate.first,
        delivery_timing: :reserved,
        subject: "test#{n}",
        body: "test#{n}\n",
        status: :reserved,
        reserved_at: time,
    )
    ReservedDeliveryJob.set(wait_until: time).perform_later(bulk_mail)
end
```

