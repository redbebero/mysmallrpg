class_name JobSimulator
extends RefCounted

static func process(job: JobDefinition, worker: Node, elapsed: float, progress: float) -> float:
	if job == null or job.work_time <= 0.0:
		return progress
	progress += maxf(0.0, elapsed)
	while progress >= job.work_time:
		if not job.run(worker):
			break
		progress -= job.work_time
	return progress
