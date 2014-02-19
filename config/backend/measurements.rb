MEAS_TYPES = [
  {
    name: "batt_u",
    unit: "V",
    comm: {
      command: ['3'],
      response_size: 2,
      coefficient_linear: 0.0777126099706744868,
      coefficient_offset: 0,
      interval: 0.5
    },
    important: true,
    archive: {
      significant: 2.0,
      min_time: 2.0,
      max_time: 3600.0
    }
  },
  {
    name: "i_gen_batt",
    unit: "A",
    comm: {
      command: ['4'],
      response_size: 2,
      coefficient_linear: 0.191,
      coefficient_offset: -512,
      interval: 0.5
    },
    important: true,
    archive: {
      significant: 1.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  },
  {
    name: "i_gen_resist",
    unit: "A",
    comm: {
      command: ['5'],
      response_size: 2,
      coefficient_linear: 0.191,
      coefficient_offset: -512,
      interval: 0.2
    },
    archive: {
      significant: 2.0,
      min_time: 2.0,
      max_time: 3600.0
    }
  },
  {
    name: "i_inverters",
    unit: "A",
    comm: {
      command: ['6'],
      response_size: 2,
      coefficient_linear: 0.191,
      coefficient_offset: -512,
      interval: 2.0
    },
    archive: {
      significant: 1.0,
      min_time: 5.0,
      max_time: 3600.0
    }
  },
  {
    name: "imp_per_min",
    unit: "imp/min",
    comm: {
      command: ['l'],
      response_size: 2,
      coefficient_linear: 60.0,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 400.0,
      min_time: 2.0,
      max_time: 3600.0
    }
  },
  {
    name: "coil_1_u",
    unit: "V",
    comm: {
      command: ['0'],
      response_size: 2,
      coefficient_linear: 0.0777126099706744868,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 2.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  },
  {
    name: "coil_2_u",
    unit: "V",
    comm: {
      command: ['1'],
      response_size: 2,
      coefficient_linear: 0.0777126099706744868,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 2.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  },
  {
    name: "coil_3_u",
    unit: "V",
    comm: {
      command: ['2'],
      response_size: 2,
      coefficient_linear: 0.0777126099706744868,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 2.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  },
  {
    name: "res_pwm",
    unit: "lvl",
    comm: {
      command: ['p'],
      response_size: 2,
      coefficient_linear: 1.0,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 2.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  },
  {
    name: "res_pwm_avg",
    unit: "lvl",
    comm: {
      command: ['q'],
      response_size: 2,
      coefficient_linear: 1.0,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 1.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  },
  {
    name: "outputs",
    unit: "bit vector",
    comm: {
      command: ['o'],
      response_size: 1,
      coefficient_linear: 1.0,
      coefficient_offset: 0,
      interval: 2.0
    },
    archive: {
      significant: 1.0,
      min_time: 1.0,
      max_time: 3600.0
    }
  }
]