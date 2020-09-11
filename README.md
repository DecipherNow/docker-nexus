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

The Nexus release cycle is extremely short and updates are often made to remedy security vulnerabilities.  Therefore, this repository is configured to build from the latest released version of Nexus to ensure the latest security patches are included.

To build new images from this repository run:

        make

This will build the following images:

        deciphernow/nexus:latest
        deciphernow/nexus:<major>
        deciphernow/nexus:<major>.<minor>
        deciphernow/nexus:<major>.<minor>.<patch>
        deciphernow/nexus:<major>.<minor>.<patch>-<build>

## Publishing

In order to publish latest released version of Nexus run:

        make publish

This will push the following images:

        deciphernow/nexus:latest
        deciphernow/nexus:<major>
        deciphernow/nexus:<major>.<minor>
        deciphernow/nexus:<major>.<minor>.<patch>
        deciphernow/nexus:<major>.<minor>.<patch>-<build>

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
