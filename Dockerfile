# Use the .NET 7.0 SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project file and restore the dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the files and publish the app
COPY . ./
RUN dotnet publish -c Release -o out

# Use the .NET 7.0 runtime image as the base image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published app from the build stage
COPY --from=build /app/out ./

# Set the entrypoint for the container
ENTRYPOINT ["dotnet", "RazorPagesMovie.dll"]