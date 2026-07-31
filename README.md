# Benchmark for SPARQL updates on partitioned RDF streams using Fintan

## Installation
To execute the benchmark, please first follow the instructions in the respective install folders:
- fintan
- java/jdk-23
- jena

## Execution
After installing all the prerequisites, you can execute the two benchmarking pipelines:
- benchmark/unimorph-arq.sh (baseline)
- benchmark/unimorph-fintan-presplit.sh (partitioned RDF streams)

The execution time and paramters will be printed to sout. 

If execution hangs (esp. with ARQ), try calling the JRE with more heap space using the command Xmx32g or higher.

## Results
Results and statistics for multiple machines and configurations are included in the folder [results](results).


## Authors and Maintainers
* **Christian Fäth** - christian.faeth@uni-a.de
* **Luis Glaser** - louis.glaser@uni-a.de
* **Christian Chiarcos** - christian.chiarcos@uni-a.de

## Acknowledgements
* John Sylak-Glassman, Christo Kirov, David Yarowsky, and Roger Que (2015), A language-independent feature schema for inflectional morphology. In Proceedings of the 53rd Annual Meeting of the Association for Computational Linguistics and the 7th International Joint Conference on Natural Language Processing (Volume 2: Short Papers), pages 674–680, Beijing, China. Association for Computational Linguistics.

* Christian Chiarcos, and Maria Sukhareva (2015). OLiA - Ontologies of Linguistic Annotation, SWJ (Semantic Web Journal) 6(4): 379-386.

* Fäth C., Chiarcos C., Ebbrecht B., Ionov M. (2020), Fintan - Flexible, Integrated Transformation and Annotation eNgineering. In: Proceedings of the 12th Language Resources and Evaluation Conference. LREC 2020. pp 7212-7221.

## Licenses
The repositories for Fintan are being published under multiple licenses. All native code and documentation falls under an Apache 2.0 license. [LICENSE.main](LICENSE.main.txt). The benchmark relies on data derived from [UniMorph](https://unimorph.github.io/) under CC BY-SA 3.0, see [LICENSE.data](LICENSE.data.txt). The OLiA annotation model for UniMorph is published under CC BY 3.0, see [LICENSE.olia](LICENSE.olia.txt).

### LICENSE.main (Apache 2.0)
```
├── https://github.com/acoli-repo/fintan-benchmark/ 
	└──[ see exceptions below ]
```
### LICENSE.data (CC-BY-SA 3.0)
```
└── https://github.com/acoli-repo/fintan-benchmark/ 
	└── benchmark/data/sqi-conll-rdf* 
```
### LICENSE.olia (CC-BY 3.0)
```
└── https://github.com/acoli-repo/fintan-backend/  
	└── benchmark/data/unimorph.owl
```

