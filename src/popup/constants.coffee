
INITIAL_STATE = 0
DRAFT_STATE   = 1

module.exports =
  # Script state
  INITIAL_STATE: INITIAL_STATE
  DRAFT_STATE: DRAFT_STATE

  INITIAL_SCRIPT:
    enable: false
    source: '// Here you can type your script'
    state: INITIAL_STATE

  INITIAL_WEBSITES:
    all: []
    current: null
    selected: null

  # Storage
  WEBSITES_KEY: 'websites'
  SCRIPT_KEY_PREFIX: 'script'
  WEBSITE_STRUCTURE:
    scripts: 0
