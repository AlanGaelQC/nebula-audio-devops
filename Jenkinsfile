pipeline {
  agent any

  environment {
    REGISTRY = "localhost:5001"
    TAG = "0.1.0"
    NAMESPACE = "finlab"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Integration/E2E/Perf (local)') {
      steps {
        sh '''
          echo "NOTA: Este Jenkinsfile está pensado para ejecutarse en laboratorio local."
          echo "Se asume que el cluster k3d finlab existe y el registry local está activo."
        '''
      }
    }

    stage('Build Images') {
      steps {
        sh '''
          docker build -t ${REGISTRY}/finlab/backend:${TAG} ./apps/backend
          docker build -t ${REGISTRY}/finlab/frontend:${TAG} ./apps/frontend
          docker push ${REGISTRY}/finlab/backend:${TAG}
          docker push ${REGISTRY}/finlab/frontend:${TAG}
        '''
      }
    }

    stage('Deploy (Helm)') {
      steps {
        sh '''
          helm upgrade --install finlab ./infra/helm/finlab -n ${NAMESPACE} --create-namespace
          kubectl -n ${NAMESPACE} rollout status deploy/backend
          kubectl -n ${NAMESPACE} rollout status deploy/frontend
        '''
      }
    }

    stage('Smoke + E2E') {
      steps {
        sh '''
          echo "Port-forward recomendado: kubectl -n finlab port-forward svc/frontend 8080:80 &"
          echo "Luego ejecutar Playwright con E2E_BASE_URL=http://localhost:8080"
        '''
      }
    }

    stage('Perf (k6)') {
      steps {
        sh '''
          echo "Ejemplo: k6 run tests/perf/smoke.js"
        '''
      }
    }
  }
}
