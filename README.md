# docker-nexus

A Docker image for Sonatype Nexus Repository Manager.

## Running

To run this image:

        docker run -p 8081:8081 decipher/nexus:latest

If you need data to persist after the conainer exits you can mount a volume:

        docker run -p 8081:8081 -v ${PWD}/sonatype-work:/var/lib/nexus/sonatype-work decipher/nexus:latest

Lastly, it is not required but we recommend you run the container as an arbitrary user:

        docker run -p 8081:8081 -v ${PWD}/sonatype-work:/var/lib/nexus/sonatype-work -u 1024 decipher/nexus:latest

## Using

This image launches with the default administrator username and password.  In the above examples you can access the web interface at http://localhost:8081.

## Building

To build a new image from this repository:

        ./build.sh

This will build and tag the version of Nexus defined in the [VERSION](VERSION) file. Alternatively, you can build a specific version of Nexus by providing a version number:

        ./build.sh 3.15.0-01

## Publishing

To publish the image built by this repository:

        ./publish.sh

This will publish the tags corresponding to the version defined in the [VERSION](VERSION) file. Alternatively, you can publish a specific tags by providing a version number:

        ./publish.sh 3.15.0-01

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
