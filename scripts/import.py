#!/usr/bin/env python

import sys
#sys.path.insert(0, "/opt/handler/lib/python")
sys.path.insert(0, "./lib/python")

from eupath import GeneListDatasetPreparer

def main():
    GeneListDatasetPreparer.execute()

if __name__ == "__main__":
    sys.exit(main())
