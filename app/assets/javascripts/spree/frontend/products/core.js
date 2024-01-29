const SpreeFlexiVariants = { product: {}, jobs: {} };

SpreeFlexiVariants.jobs = {
  // Parameters
  jobs: [],

  // Methods
  _createJob: function (callback) {
    return {
      id: Symbol(),
      callback,
    };
  },
  add: function (callback) {
    this.jobs.push(this._createJob(callback));
  },
  remove: function (id) {
    this.jobs = this.jobs.filter((job) => job.id !== id);
  },
  run: function () {
    this.jobs.forEach((job) => {
      job.callback();
      this.remove(job.id);
    });
  },
};
