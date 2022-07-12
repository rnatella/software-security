#include "libxml/parser.h"
#include "libxml/tree.h"

int main(int argc, char **argv) {
    if (argc != 2){
        return(1);
    }

    xmlInitParser();

    xmlDocPtr doc = xmlReadFile(argv[1], NULL, 0);

    xmlDocDump(stdout, doc);

    if (doc != NULL) {
        xmlFreeDoc(doc);
    }

    xmlCleanupParser();

    return(0);
}
