# customized controller to enqueue recurring tasks in the default locale
class CustomRecurringTasksController < MissionControl::Jobs::RecurringTasksController
  def update
    job = nil
    I18n.with_locale(::I18n.default_locale) do
      job = @recurring_task.enqueue
    end
    if job && job.successfully_enqueued?
      redirect_to application_job_path(@application, job.job_id),
        notice: "Enqueued recurring task #{@recurring_task.id}"
    else
      redirect_to application_recurring_task_path(@application, @recurring_task.id),
        alert: "Something went wrong enqueuing this recurring task"
    end
  end
end
