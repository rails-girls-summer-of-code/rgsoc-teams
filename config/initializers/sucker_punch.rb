unless Rails.env.production?
  SuckerPunch.config do
    queue name: :submissions, worker: SubmissionWorker, workers: 5
  end
end
