def release(string, size = 3):
  """
  Turn the return of /etc/redhat-release (e.g. "CentOS Linux release 7.4.1708 (Core)") to a version (e.g. 7, 7.4 or 7.4.1708).
  """
  import re
  version = re.match(re.compile(r'^.* ([\d.]+) \(.+\)$'), string.strip()).group(1)
  return '.'.join(str(version).split('.')[:size])

class FilterModule(object):
  """Filter for turning a full yum version to it's simple representation"""

  def filters(self):
    return {
      'release': release,
    }
