import sys
import json
from array import array
import six.moves.cPickle as pickle

class CJsonEncoder(json.JSONEncoder):
    ''' json encoder '''

    def default(self, obj):
        if isinstance(obj, array):
        	  return str(obj.tolist())
        else:
            return json.JSONEncoder.default(self, obj)

print json.dumps(pickle.load(open(sys.argv[1], 'rb')), indent=4, cls=CJsonEncoder)

