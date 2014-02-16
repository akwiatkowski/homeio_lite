ACTION_TYPES = [
  {
    name: "start_total_brake",
    comm: {
      command: ['w'],
      response_size: 1,
      response_ok: 21
    },
  },

  {
    name: "turn_off_brake",
    comm: {
      command: ['W'],
      response_size: 1,
      response_ok: 20
    },
  },

  {
    name: "test_zero",
    comm: {
      command: ['s'],
      response_size: 1,
      response_ok: 0
    },
  },

  {
    name: "test_numbers",
    comm: {
      command: ['t'],
      response_size: 2,
      response_ok: 12345
    },
  },

  {
    name: "decr_std_batt_u",
    comm: {
      command: ['k'],
      response_size: 2,
      response_ok: nil # response variable
    },
  },

  {
    name: "inc_std_batt_u",
    comm: {
      command: ['K'],
      response_size: 2,
      response_ok: nil # response variable
    },
  },

  {
    name: "output_1_off",
    comm: {
      command: ['a'],
      response_size: 1,
      response_ok: 0
    },
  },

  {
    name: "output_2_off",
    comm: {
      command: ['b'],
      response_size: 1,
      response_ok: 1
    },
  },

  {
    name: "output_3_off",
    comm: {
      command: ['c'],
      response_size: 1,
      response_ok: 2
    },
  },

  {
    name: "output_4_off",
    comm: {
      command: ['d'],
      response_size: 1,
      response_ok: 3
    },
  },

  {
    name: "output_5_off",
    comm: {
      command: ['d'],
      response_size: 1,
      response_ok: 4
    },
  },

  {
    name: "output_1_on",
    comm: {
      command: ['A'],
      response_size: 1,
      response_ok: 10
    },
  },

  {
    name: "output_2_on",
    comm: {
      command: ['B'],
      response_size: 1,
      response_ok: 11
    },
  },

  {
    name: "output_3_on",
    comm: {
      command: ['C'],
      response_size: 1,
      response_ok: 12
    },
  },

  {
    name: "output_4_on",
    comm: {
      command: ['D'],
      response_size: 1,
      response_ok: 13
    },
  },

  {
    name: "output_5_on",
    comm: {
      command: ['E'],
      response_size: 1,
      response_ok: 13
    },
  },
]